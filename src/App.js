import logo from "./logo.svg";
import "./App.css";
import { Container, Col, Row, Button, Form, Card } from "react-bootstrap";

// Blockchain imports
import abi from "./utils/BlockchainReviews.json";
import { ethers } from "ethers";
import React, { useEffect, useState } from "react";

// Connect smart contract
export default function Home() {
  // Contract Address & ABI
  const contractAddress = "0x9500C70230e417831f3f7aFB3615834Bd116d47F";
  const contractABI = abi.abi;

function App() {
  const [clicked, setClicked] = useState(false);
  const [stars, setStars] = useState(1);
  const [review, setReview] = useState("");
  const [reviews, setReviews] = useState([]);

  const onMouseOver = (rating) => {
    if (clicked) return;

    [...Array(rating)].map((x, i) => {
      document.querySelector(`#star-${i + 1}`).classList.replace("far", "fas");
    });
  };

  const onMouseOut = (rating) => {
    if (clicked) return;

    [...Array(rating)].map((x, i) => {
      document.querySelector(`#star-${i + 1}`).classList.replace("fas", "far");
    });
  };

  const onClick = (rating) => {
    setClicked(true);
    setStars(rating);
    // Reset
    [...Array(5)].map((x, i) => {
      document.querySelector(`#star-${i + 1}`).classList.replace("fas", "far");
    });

    // highlight
    [...Array(rating)].map((x, i) => {
      document.querySelector(`#star-${i + 1}`).classList.replace("far", "fas");
    });
  };

  const resetForm = (e) => {
    e.preventDefault();

    // Reset
    [...Array(5)].map((x, i) => {
      document.querySelector(`#star-${i + 1}`).classList.replace("fas", "far");
    });

    setReview("");
    setStars(1);
    setClicked(false);
  };

  const submitReview = (e) => {
    e.preventDefault();
    const newReview = {
      rating: stars,
      description: review,
    };

    setReviews([...reviews, newReview]);
    resetForm(e);
  };

  const deleteReview = (e, index) => {
    e.preventDefault();

    const clone = [...reviews];
    const newState = clone.filter((x, i) => i !== index);
    setReviews(newState);
  };

  return (
    <Container fluid className="App text-light text-center">
      <h1>Blockchain Review System</h1>
      <Col md={{ span: 6, offset: 3 }}>
        <Row className="mt-5">
          <Col>
            {[...Array(5)].map((x, i) => {
              return (
                <i
                  key={i}
                  className="far fa-star display-4"
                  id={`star-${i + 1}`}
                  onMouseOver={(e) => onMouseOver(i + 1)}
                  onMouseOut={(e) => onMouseOut(i + 1)}
                  onClick={(e) => onClick(i + 1)}
                />
              );
            })}
          </Col>
        </Row>
        <Row className="mt-5">
          <Col>
            <Form.Group>
              <Form.Control
                as="textarea"
                rows={3}
                value={review}
                onChange={(e) => setReview(e.target.value)}
              />
            </Form.Group>
          </Col>
        </Row>
        <Row className="mt-5">
          <Col>
            <Button variant="warning" onClick={(e) => resetForm(e)}>
              reset
            </Button>
            <Button
              variant="success"
              onClick={(e) => submitReview(e)}
              disabled={review === ""}
            >
              submit
            </Button>
          </Col>
        </Row>
        <Row className="mt-5">
          <Col>
            {reviews.map((r, rIndex) => {
              return (
                <Card className="mt-3 mb-3 text-dark">
                  <Card.Body>
                    {[...Array(r.rating)].map((s, sIndex) => {
                      return <i className="fas fa-star text-warning" />;
                    })}
                    <p>{r.description}</p>
                  </Card.Body>
                  <Card.Footer>
                    <Button
                      variant="danger"
                      onClick={(e) => deleteReview(e, rIndex)}
                    >
                      Delete
                    </Button>
                  </Card.Footer>
                </Card>
              );
            })}
          </Col>
        </Row>
      </Col>
    </Container>
  );
}

export default App;